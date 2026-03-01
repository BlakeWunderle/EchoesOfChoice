using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class CorruptedTreant : BaseFighter
    {
        public CorruptedTreant(int level = 14)
        {
            Level = level;
            Health = Stat(290, 330, 8, 12, 14);
            MaxHealth = Health;
            PhysicalAttack = Stat(40, 48, 3, 5, 14);
            PhysicalDefense = Stat(32, 38, 3, 4, 14);
            MagicAttack = Stat(14, 18, 1, 2, 14);
            MagicDefense = Stat(24, 30, 2, 3, 14);
            Speed = Stat(22, 28, 1, 3, 14);
            Abilities = new List<Ability>() { new VineWhip(), new RootSlam(), new BarkShield() };
            CharacterType = "Corrupted Treant";
            Mana = Stat(20, 26, 2, 3, 14);
            MaxMana = Mana;
            CritChance = 15;
            CritDamage = 4;
            DodgeChance = 8;
        }

        public CorruptedTreant(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new CorruptedTreant(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(6, 10);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 3);
            PhysicalDefense += random.Next(2, 3);
            MagicAttack += random.Next(1, 2);
            MagicDefense += random.Next(1, 3);
            Speed += random.Next(1, 2);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
