using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class CorruptedTreant : BaseFighter
    {
        public CorruptedTreant(int level = 16)
        {
            Level = level;
            Health = Stat(300, 340, 8, 12, 16);
            MaxHealth = Health;
            PhysicalAttack = Stat(48, 56, 3, 5, 16);
            PhysicalDefense = Stat(40, 46, 3, 5, 16);
            MagicAttack = Stat(16, 22, 1, 2, 16);
            MagicDefense = Stat(30, 36, 2, 4, 16);
            Speed = Stat(26, 32, 1, 3, 16);
            Abilities = new List<Ability>() { new VineWhip(), new RootSlam(), new BarkShield() };
            CharacterType = "Corrupted Treant";
            Mana = Stat(24, 30, 2, 4, 16);
            MaxMana = Mana;
            CritChance = 16;
            CritDamage = 4;
            DodgeChance = 11;
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
