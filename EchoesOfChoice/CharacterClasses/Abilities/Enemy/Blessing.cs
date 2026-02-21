using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class Blessing : Ability
    {
        public Blessing()
        {
            Name = "Blessing";
            FlavorText = "A prayer of mending knits flesh and bone.";
            ModifiedStat = StatEnum.Health;
            Modifier = 8;
            impactedTurns = 0;
            UseOnEnemy = false;
            ManaCost = 5;
        }
    }
}
