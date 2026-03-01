using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Wraith : BaseFighter
    {
        public Wraith(int level = 7)
        {
            Level = level;
            Health = Stat(123, 143, 5, 9, 7);
            MaxHealth = Health;
            PhysicalAttack = Stat(10, 14, 0, 2, 7);
            PhysicalDefense = Stat(12, 16, 1, 2, 7);
            MagicAttack = Stat(35, 43, 3, 5, 7);
            MagicDefense = Stat(18, 24, 2, 3, 7);
            Speed = Stat(31, 37, 2, 4, 7);
            Abilities = new List<Ability>() { new SoulDrain(), new Blight(), new Terrify() };
            CharacterType = "Wraith";
            Mana = Stat(18, 22, 2, 4, 7);
            MaxMana = Mana;
            CritChance = 24;
            CritDamage = 3;
            DodgeChance = 26;
        }

        public Wraith(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Wraith(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(4, 7);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 4);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(0, 2);
            PhysicalDefense += random.Next(1, 2);
            MagicAttack += random.Next(2, 3);
            MagicDefense += random.Next(1, 3);
            Speed += random.Next(2, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
