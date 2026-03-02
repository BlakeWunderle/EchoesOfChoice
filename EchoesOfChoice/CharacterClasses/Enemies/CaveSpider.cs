using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class CaveSpider : BaseFighter
    {
        public CaveSpider(int level = 18)
        {
            Level = level;
            Health = Stat(362, 402, 10, 14, 18);
            MaxHealth = Health;
            PhysicalAttack = Stat(70, 80, 5, 7, 18);
            PhysicalDefense = Stat(30, 36, 2, 4, 18);
            MagicAttack = Stat(16, 22, 1, 2, 18);
            MagicDefense = Stat(26, 32, 2, 3, 18);
            Speed = Stat(38, 44, 3, 5, 18);
            Abilities = new List<Ability>() { new VenomousBite(), new Web(), new PoisonCloud() };
            CharacterType = "Cave Spider";
            Mana = Stat(26, 32, 2, 4, 18);
            MaxMana = Mana;
            CritChance = 28;
            CritDamage = 4;
            DodgeChance = 24;
        }

        public CaveSpider(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new CaveSpider(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 8);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 3);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(0, 2);
            MagicDefense += random.Next(1, 2);
            Speed += random.Next(2, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
