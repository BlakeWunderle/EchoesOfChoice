using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Entangle : Ability
    {
        public Entangle()
        {
            Name = "Entangle";
            FlavorText = "Grasping roots burst from the ground, binding the enemy in place.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
